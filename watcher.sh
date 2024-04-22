export NAMESPACE=sre
export DEPLOYMENT_NAME=swype-app
export MAX_RESTART=5

while true
do
    RESTARTS_COUNT=$(kubectl get pods -n $NAMESPACE | grep $DEPLOYMENT_NAME | awk '{print $4}')

    echo "$(date) - Current number of restarts for $DEPLOYMENT_NAME: $RESTARTS_COUNT"

    # Check Restart Limit
    if [ "$RESTARTS_COUNT" -gt "$MAX_RESTART" ]; then
        echo "$(date) - Number of restarts exceeded maximum allowed. Scaling down $DEPLOYMENT_NAME deployment..."
        kubectl scale --replicas=0 deployment/$DEPLOYMENT_NAME -n $NAMESPACE
        break
    else
        echo "$(date) - Pausing for 60 seconds..."
        sleep 60
    fi
done