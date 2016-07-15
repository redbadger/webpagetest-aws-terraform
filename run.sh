#!/bin/bash

terraform get
terraform $1 \
  -var-file=$2 \
