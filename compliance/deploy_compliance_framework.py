#!/usr/bin/env python3
"""Utility script to apply Compliance Manager HCL using local Terraform.

It automatically resolves the project number and organization ID using gcloud,
and passes them as variables to terraform apply.
"""

import argparse
import json
import os
import subprocess
import sys

def run_cmd(cmd, cwd=None, capture=False):
    if capture:
        res = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
        if res.returncode != 0:
            print(f"[ERROR] Command failed: {' '.join(cmd)}\nStderr: {res.stderr.strip()}", file=sys.stderr)
            sys.exit(1)
        return res.stdout.strip()
    else:
        res = subprocess.run(cmd, cwd=cwd)
        if res.returncode != 0:
            sys.exit(res.returncode)

def get_project_details(project_id):
    print(f"--> Looking up project details for {project_id}...")
    out = run_cmd(["gcloud", "projects", "describe", project_id, "--format=json"], capture=True)
    return json.loads(out)

def get_organization_id(project_details):
    parent = project_details.get("parent")
    if not parent:
        raise ValueError("Project has no parent (no organization or folder)")
    
    parent_type = parent.get("type")
    parent_id = parent.get("id")
    
    while parent_type == "folder":
        print(f"    Project is under folder {parent_id}. Walking up hierarchy...")
        out = run_cmd(["gcloud", "resource-manager", "folders", "describe", parent_id, "--format=json"], capture=True)
        folder_resp = json.loads(out)
        parent_str = folder_resp.get("parent")
        if not parent_str:
            raise ValueError(f"Folder {parent_id} has no parent")
        
        parts = parent_str.split("/")
        parent_type = parts[0]
        parent_id = parts[1]
        
        if parent_type == "folders":
            parent_type = "folder"
        elif parent_type == "organizations":
            parent_type = "organization"
            
    if parent_type == "organization":
        print(f"    Found Organization ID: {parent_id}")
        return parent_id
        
    raise ValueError(f"Could not find organization parent (stopped at {parent_type}/{parent_id})")

def main():
    parser = argparse.ArgumentParser(description="Apply Compliance HCL.")
    parser.add_argument("--project_id", required=True, help="GCP Project ID")
    args = parser.parse_args()
    
    project_id = args.project_id
    
    # 1. Resolve project details and org ID
    try:
        project_details = get_project_details(project_id)
        project_number = project_details.get("projectNumber")
        organization_id = get_organization_id(project_details)
    except Exception as e:
        print(f"[ERROR] Failed to resolve hierarchy: {e}", file=sys.stderr)
        sys.exit(1)
        
    print(f"\nResolved Project Number: {project_number}")
    print(f"Resolved Organization ID: {organization_id}")
    
    # 2. Run Terraform
    script_dir = os.path.dirname(os.path.realpath(__file__))
    
    print("\n--> Running terraform init...")
    run_cmd(["terraform", "init"], cwd=script_dir)
    
    print("\n--> Running terraform apply...")
    # Pass the resolved project number and org ID to Terraform
    run_cmd([
        "terraform", "apply",
        f"-var=project_id={project_number}",
        f"-var=organization_id={organization_id}",
        "-auto-approve"
    ], cwd=script_dir)

if __name__ == "__main__":
    main()
