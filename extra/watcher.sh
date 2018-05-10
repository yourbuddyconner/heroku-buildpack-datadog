#!/usr/bin/env bash

while true; do
  echo "AGENT PID: $DD_AGENT_PID"
  echo "TRACE AGENT PID: $DD_TRACE_AGENT_PID"

  # Get the current process count.
  PROC_COUNT=$(ps | wc -l)
  echo "PROC_COUNT: $PROC_COUNT"

  # Set prcoess threshold is prcoesses + 3 (ps header, ps command, wc)
  PROC_THRESHOLD=4
  if [ -n $DD_TRACE_AGENT_PID ]; then
    PROC_THRESHOLD=$((PROC_THRESHOLD + 1))
  fi
  echo "PROC_THRESHOLD: $PROC_THRESHOLD"

  # If the only processes running are the agent, kill and exist
  if [ "$PROC_COUNT" -le "$PROC_THRESHOLD" ]; then
    # Send SIGTERM to the agent process
    kill -15 $DD_AGENT_PID

    # Send SIGTERM to the trace agent process
    if [ -n $DD_TRACE_AGENT_PID ]; then
      kill -15 $DD_TRACE_AGENT_PID
    fi

    break;
  fi

  sleep 15
done
