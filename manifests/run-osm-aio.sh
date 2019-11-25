#/bin/#!/usr/bin/env bash

echo "Creating Volumes"
kubectl apply -f volume-claims.yaml
echo "Loading database with area data (will take some time)"
kubectl apply -f init-database.yaml
time kubectl wait --for condition=complete --timeout 1h jobs/init-osm-db
echo "Starting tiles server"
kubectl apply -f deployment-aio.yaml
time kubectl wait --for=condition=ready deploy/osm-tilesserver

kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
echo "Tile service is available through NodePort :"
kubectl get svc/osm-tiles
