// TODO Waiting for filtering and selection PR to be merged.

# Use Case: Trigger File Processing (Ensuring File Completeness)

In this integration, we will build a workflow that processes large data files only after a corresponding "trigger" or "marker" file appears. This pattern is critical for avoiding race conditions where a file listener might read a large file while it is still being written or uploaded. The presence of the trigger file acts as a signal that the data file is complete and ready for consumption.

## Scenario

A remote system uploads a large data file (e.g., sales.csv) to an FTP directory, which can take several minutes. After the upload is fully complete, the system uploads an empty "trigger" file (e.g., sales.csv.ready). The integration must:

1. Watch for *.ready files.
2. When a .ready file is found, derive the name of the corresponding .csv file.
3. Read and process the .csv file.
4. Clean up by archiving both files.
   