# Overview

### Deployment spec

	  Stages: single (only production)
	  Network: single subnet on single vpc

## Steps

 1. Pick Domain name ( Namecheap )
 2. Setup VPC ( Terraform or awless )
 3. Spin Linux Server ( Terraform or awless )
 4. Install Nginx ( Shell script )
 5. Configure Nginx to serve Static files ( Shell script)
 6. Configure Nginx VHost (Shell script)
 7. Sync build folder, i.e. static content from local to server (rsync/scp)
 8. Configure DNS record ( Namecheap )

