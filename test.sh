#!/bin/bash

echo "Enter Company Name"
read name
sed -i "s/com  = \"hangaramit\"/com = \"$name\"/g" ./custom_vpc/locals.tf
echo "File updated with Company Name: $name"