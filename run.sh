# docker buildx create --use --name docker_single_cell_pipeline_builder
# docker buildx inspect --bootstrap
docker buildx use docker_single_cell_pipeline_builder
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t tronghieunguyen/single_cell_pipeline \
    --push . 