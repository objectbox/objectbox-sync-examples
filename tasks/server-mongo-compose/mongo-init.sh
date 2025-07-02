#!/bin/bash
# Initialize MongoDB replica set
echo "Initializing MongoDB replica set..."

# Initial short wait
sleep 2

# Connect to MongoDB and initialize replica set with retries
MAX_ATTEMPTS=10
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
  echo "Attempt $ATTEMPT of $MAX_ATTEMPTS to connect to MongoDB..."
  
  if mongosh --host mongo:27017 --quiet --eval "db.runCommand('ping').ok" &>/dev/null; then
    echo "MongoDB is responsive, initializing replica set..."
    
    mongosh --host mongo:27017 <<EOF
  try {
    const status = rs.status();
    if (status.ok !== 1) {
      throw new Error("Replica set not initialized");
    }
    print("Replica set already initialized");
  } catch (e) {
    print("Initializing replica set...");
    rs.initiate({
      _id: "rs0",
      members: [
        { _id: 0, host: "mongo:27017" }
      ]
    });
    print("Replica set initialization requested");
  }
EOF
    echo "MongoDB initialization script completed"
    exit 0
  else
    echo "MongoDB not ready yet, waiting..."
    sleep 2
    ATTEMPT=$((ATTEMPT+1))
  fi
done

echo "Failed to connect to MongoDB after $MAX_ATTEMPTS attempts"
exit 1
