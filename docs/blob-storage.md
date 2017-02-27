# Azure Blob Storage Specification

Device Management client requires addiiotnal storage that is used for storing data that cannot be stored in the device twin. For example, this includes appx files, log files, certificate files etc. The DM client can both upload data to and download data from the blob storage.

## Desired Properties

The `"desired.microsoft.management.externalStorage"` property is defined like this:

<pre>
"desired" : {
    "microsoft" : {
        "management" : {
            "externalStorage" : {
                "blob" : {
                    "connectionString" : "<i>Connection String</i>",
                    "defaultContainer" : "<i>see below</i>"
                }
            }
        }
    }
}
</pre>
