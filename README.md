# Node Hello CI/CD Pipeline

This repository demonstrates an automated CI/CD workflow using GitHub Actions to lint a Node.js app, build a Docker image with Buildx, and push it to Docker Hub—no local setup required beyond cloning.

**Repository:** [https://github.com/AhmedZeins/node-hello.git](https://github.com/AhmedZeins/node-hello.git)

---

## Prerequisites

* **GitHub** access to this repository
* **Docker Hub** account

## Setup

1. **Clone the repo**

   ```bash
   git clone https://github.com/AhmedZeins/node-hello.git
   ```

2. **Configure GitHub Secrets**

   * In GitHub, navigate to **Settings → Secrets and variables → Actions**
   * Add the following secrets:

     * `DOCKERHUB_USERNAME`: your Docker Hub username
     * `DOCKERHUB_TOKEN`: a Docker Hub access token with push rights

---

## Running the Pipeline

The pipeline (`lint&build`) runs automatically on every push to the **master** branch.

* **To trigger manually:**

  1. Go to the **Actions** tab in GitHub.
  2. Select **lint\&build**.
  3. Click **Run workflow** (choose `master`).

## Verifying the Result

After the workflow completes successfully:

1. Log in to Docker Hub.
2. Visit `https://hub.docker.com/r/<your-username>/node-hello`.
3. Confirm the `latest` tag exists.

---

