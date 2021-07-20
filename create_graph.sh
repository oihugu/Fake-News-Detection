sudo rm -rf build

sudo mkdir build

sudo docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$(pwd)/build/neo4j/data:/data \
    --volume=$(pwd)/neo4j/logs:/logs \
    --volume=$(pwd)/neo4j/import:/var/lib/neo4j/import \
    --volume=$(pwd)/neo4j/plugins:/plugins 
    --name FNDetection \
    -d \
    neo4j

sudo docker stop FNDetection