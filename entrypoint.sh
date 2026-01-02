#!/bin/sh

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export BUILDKIT_INLINE_CACHE=1
export COMPOSE_PROJECT_NAME=${HARBOR_HASH:-harbor}
export DOCKER_TLS_CERTDIR=

cp -r /mount/* /host/

dockerd --storage-driver=vfs --insecure-registry registry:5000 --registry-mirror http://registry:5000 &
wait $! || exit 1 &
while ! docker info >/dev/null 2>&1; do sleep 1; done


REGISTRY="${REGISTRY:-registry:5000}"
PROJECT="${COMPOSE_PROJECT_NAME:-$(basename "$PWD")}"

echo "Pulling images from $REGISTRY..."
for service in $(docker compose config --services); do
    echo "Pulling $REGISTRY/$PROJECT-$service..."
    docker pull "$REGISTRY/$PROJECT-$service" || true
    echo "Tagging $REGISTRY/$PROJECT-$service as $PROJECT-$service..."
    docker tag "$REGISTRY/$PROJECT-$service" "${PROJECT}-$service" || true
    echo "Tagging $REGISTRY/$PROJECT-$service as $PROJECT_$service..."
    docker tag "$REGISTRY/$PROJECT-$service" "${PROJECT}_$service" || true
done

if [ "$BUILD_HARBOR" = "true" ]; then
    echo "Creating Docker containers..."
    docker compose create
    echo "Tagging and pushing images to local registry..."
    docker images --format '{{.Repository}}:{{.Tag}}' \
    | grep "^${COMPOSE_PROJECT_NAME}-" \
    | while read img; do
          us=$(echo "$img" | sed "s/${COMPOSE_PROJECT_NAME}-/${COMPOSE_PROJECT_NAME}_/")
          docker tag "$img" "$us"
          docker tag "$img" "registry:5000/$img"
          docker tag "$img" "registry:5000/$us"
          echo " Pushing registry:5000/$img..."
          docker push "registry:5000/$img"
          echo " Pushing registry:5000/$us..."
          docker push "registry:5000/$us"
        done
    echo "Docker containers created."
else
    echo "Pulling latest compose images..."
    docker compose pull
fi

echo "Starting Harbor services..."
docker compose up --no-build
