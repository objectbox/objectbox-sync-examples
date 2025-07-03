#!/bin/bash
# Initialize MongoDB replica set
echo "Initializing MongoDB replica set..."

# Initial short wait
sleep 2

# Connect to MongoDB and initialize replica set with retries
MONGO_HOST=${MONGO_HOST:-mongo:27017}  # Customize by setting env var MONGO_HOST
MAX_ATTEMPTS=10
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
  echo "Attempt $ATTEMPT of $MAX_ATTEMPTS to connect to MongoDB at '$MONGO_HOST'..."
  
  if mongosh --host "$MONGO_HOST" --quiet --eval "db.runCommand('ping').ok" &>/dev/null; then
    echo "MongoDB is responsive, initializing replica set..."
    
    mongosh --host "$MONGO_HOST" <<EOF
  try {
    const status = rs.status();
    if (status.ok !== 1) {
      throw new Error("Replica set not initialized");
    }
    print("Replica set already initialized");
  } catch (e) {
    print("Initializing replica set with single node '$MONGO_HOST'...");
    rs.initiate({
      _id: "rs0",
      members: [
        { _id: 0, host: "$MONGO_HOST" }
      ]
    });
    print("Replica set initialization requested");
  }
EOF
    echo "MongoDB initialization complete; waiting a bit more to let MongoDB settle and print further logs..."
    sleep 1
    exit 0
  else
    echo "MongoDB not ready yet, waiting..."
    sleep 2
    ATTEMPT=$((ATTEMPT+1))
  fi
done

echo "Failed to connect to MongoDB after $MAX_ATTEMPTS attempts"
exit 1
