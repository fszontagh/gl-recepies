## RECEPIES TO BUILD PACKAGE FROM SOURCE 
###### (in installed gl systems)


#### - Create new recipe
1. Copy the skeleton.sh with the name of the package (like: python3)
2. Edit the new .sh file
##### Parameters:
> file_name=

The name of the downloaded source file

> url=

The direct url of the "file_name", for example:
> url=https://github.com/djlucas/make-ca/releases/download/v${version}/${file_name}

> strip=1

Strip parameter to tar

> arch=x86_64

The architecture of the package

> configure_options

The paramaters to the ./configure command. You can ommit, when no configure is needed.

##### Variables in the recipe .sh file:

**${PKG}** the path of the compiled binary. This path will be used to generate the system package's hiearchy

**${SOURCE_DIR}** is the source dir, where run the ./configure and the make command

**${1}** is equal with the __${SOURCE_DIR}__
