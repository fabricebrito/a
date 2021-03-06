## Developer Cloud Service - BEAM Java tutorial

The BEAM Java tutorial uses the Developer Cloud Sandbox service to implement a BEAM Operator to calculate the Fluorescence line height in Envisat MERIS Level 1b products.

This tutorial builds upon the BEAM tutorial created by [Brockmann Consult](http://www.brockmann-consult.de), held at the [Sentinel-3 OLCI/SLSTR and MERIS/(A)ATSR workshop 2012](http://www.sen3symposium.org/) and extends it to exploit a Cloud computing platform for its development, test and exploitation.

### Getting Started 

To run this application, you will need a Developer Cloud Sandbox that can be either requested from the ESA [Research & Service Support Portal](http://eogrid.esrin.esa.int/cloudtoolbox/) for ESA G-POD related projects and ESA registered user accounts, or directly from Terradue's [Portal](http://www.terradue.com/partners), provided user registration approval. 

A Developer Cloud Sandbox provides Earth Science data access services, and assistance tools for a user to implement, test and validate his application.
It runs in two different lifecycle modes: Sandbox mode and Cluster mode. 
Used in Sandbox mode (single virtual machine), it supports cluster simulation and user assistance functions in building the distributed application.
Used in Cluster mode (collections of virtual machines), it supports the deployment and execution of the application with the power of distributed computing processing over large datasets (leveraging the Hadoop Streaming MapReduce technology). 
### Installation 

Log on the developer sandbox and run these commands in a shell:

```bash
cd
git clone https://github.com/Terradue/dcs-beam-flh-java.git
cd dcs-beam-flh-java
mvn install
```

### Submitting the workflow

Run this command in a shell:

```bash
ciop-run
```

### Community and Documentation

To learn more and find information go to 

* [Developer Cloud Sandbox](http://docs.terradue.com/developer) service 
* [BEAM Java tutorial](http://docs.terradue.com/developer/field/ocean_color/lib_beam_flh) 

### Authors (alphabetically)

* Emmannuel Mathot 
* Fabrice Brito

### License

Copyright 2016 Terradue Srl

Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
