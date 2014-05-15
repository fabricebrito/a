#!/bin/bash

# source the ciop functions (e.g. ciop-log, ciop-getparam)
source ${ciop_job_include}

# define the exit codes
SUCCESS=0
ERR_BEAM=2
ERR_NOEXPR=3

# add a trap to exit gracefully
function cleanExit ()
{
   local retval=$?
   local msg=""
   case "$retval" in
     $SUCCESS)      msg="Processing successfully concluded";;
     $ERR_BEAM)    msg="gpt failed to process product `basename $product`";;
	*)             msg="Unknown error";;
   esac
   [ "$retval" != "0" ] && ciop-log "ERROR" "Error $retval - $msg, processing aborted" || ciop-log "INFO" "$msg"
   exit $retval
}
trap cleanExit EXIT

# create the output folder to store the output products and export it
export OUTPUTDIR=$TMPDIR/output
mkdir -p $OUTPUTDIR 

# loop and process all MERIS products
while read inputfile 
do
	# report activity in log
	ciop-log "INFO" "Retrieving $inputfile from storage"

	# retrieve the MER_RR__1P product to the local temporary folder TMPDIR provided by the framework (this folder is only used by this process)
	# the ciop-copy utility will use one of online resource available in the metadata to copy it to the TMPDIR folder
	# the utility returns the local path so the variable $retrieved contains the local path to the MERIS product
	retrieved=`ciop-copy -o $TMPDIR "$inputfile"`
	
	# check if the file was retrieved, if not exit with the error code $ERR_NOINPUT
	[ "$?" == "0" -a -e "$retrieved" ] || exit $ERR_NOINPUT
	
	# report activity in the log
	ciop-log "INFO" "Retrieved `basename $retrieved`, moving on to expression"

	mkdir -p $OUTPUTDIR/`basename $retrieved`

	# invoke the application gpt.sh with:
	# - the outputdir location defined above
	# - the operator FLH
	# - the MERIS local path (copied from the archive with ciop-copy)
	# the script gpt.sh applies the operator to the input product, compress the result (.tgz) and will write it to the $OUTPUTDIR 
	$_CIOP_APPLICATION_PATH/shared/bin/gpt.sh FLH -SsourceProduct=$retrieved -t $OUTPUTDIR/`basename $retrieved`/result.dim 1>&2 

	# check the exit code
	[ "$?" != "0" ] && exit $ERR_BEAM 

	# publish the result 
	# ciop-publish copies the beam_expr.sh result to a distributed filesystem
	ciop-log "INFO" "Publishing result"	
	ciop-publish $OUTPUTDIR/`basename $retrieved`
	
	# cleanup. Free the local directory space by deleting the input MERIS Level 1 product (copied with ciop-copy) and 
	# the result of the gpt FLH operator execution (the compressed archive in $OUTPUTDIR)
	rm -fr $retrieved $OUTPUTDIR/`basename $retrieved`

done

exit 0