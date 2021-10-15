sudo rm -rf build

sudo mkdir build

echo "\n Creating Container"
sudo docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$(pwd)/build/neo4j/data:/data \
    --volume=$(pwd)/build/neo4j/logs:/logs \
    --volume=$(pwd)/build/neo4j/import:/var/lib/neo4j/import \
    --volume=$(pwd)/build/neo4j/plugins:/plugins \
    --volume=$(pwd)/build/neo4j/temp:/temp \
    --name FNDetection \
    --env NEO4J_AUTH=none \
    -d \
    neo4j


echo "Stoping neo4j"
sudo docker exec -it FNDetection bash -c "bin/neo4j stop"
echo "OK"

echo "\n
Installing neosemantics:\t"
sudo cp ./requirements/neosemantics-4.3.0.0.jar ./build/neo4j/plugins/
echo "OK."

echo "Adding neosemantics to neo4j conf:"
sudo docker exec -it FNDetection bash -c "echo 'dbms.unmanaged_extension_classes=n10s.endpoint=/rdf' >> conf/neo4j.conf"
echo "OK"

echo "Coping input"
sudo cp ./data/input/really_shot_pt.ttl ./build/neo4j/temp/input.ttl
echo "OK"

echo "Starting neo4j"
sudo docker exec -it FNDetection bash -c "bin/neo4j start"
echo "OK"

echo "Setting up neosemantics"
sudo docker exec -it FNDetection cypher-shell "CREATE CONSTRAINT n10s_unique_uri ON (r:Resource) ASSERT r.uri IS UNIQUE"
sudo docker exec -it FNDetection cypher-shell "CALL n10s.graphconfig.init()"
echo "OK"

echo "Reading RDF"
sudo docker exec -it FNDetection cypher-shell "CALL n10s.rdf.import.inline('temp/input.ttl','Turtle')"
echo "OK"

echo "Reading input data"
sudo docker exec -it FNDetection 

echo "\nStoping Container"
sudo docker stop FNDetection