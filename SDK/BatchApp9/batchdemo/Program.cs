using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Microsoft.Azure.Batch;
using Microsoft.Azure.Batch.Auth;
using Microsoft.Azure.Batch.Common;
using Microsoft.Azure.Storage;
using Microsoft.Azure.Storage.Blob;


namespace batchdemo
{
    class Program
    {

        // Batch account credentials
        private const string BatchAccountName = "msaz203bacthaccount";
        private const string BatchAccountKey = "zNztH1ygD7l+2tc4Dzll/adSOy2YDSn9W+rCUw1e3vrlkOibh/2Wz+4+7KukMTWDaQwWUGz6SJuQKo25LZeT4w==";
        private const string BatchAccountUrl = "https://msaz203bacthaccount.southeastasia.batch.azure.com";

        // Storage account credentials
        private const string StorageAccountName = "msaz203storageacc";
        private const string StorageAccountKey = "HQ+HAzor6k/CPtgmHSoGnaNhWys/kT854dOjYz/s/qSDdQRf61c6Mzw8TQ5sgDVPPZAPJF4UV4wGrE4KnOpw0Q==";

        // Batch resource settings
        private const string PoolId = "demopool";
        private const string JobId = "demojob";

        private const string Packageid = "ffmpeg";
        private const string Packageversion = "4.2";


        private const int PoolNodeCount = 1;
        private const string PoolVMSize = "STANDARD_A1_v2";

        static void Main(string[] args)
        {
            Console.WriteLine("HELLO");

            try
            {
                CoreAsync();
            }
            finally
            {
                Console.WriteLine();
                Console.WriteLine("Program complete");
                Console.ReadLine();
            }

        }

        private static void CoreAsync()
        {
            BatchSharedKeyCredentials batchSharedKeyCredentials
                = new BatchSharedKeyCredentials(BatchAccountUrl, BatchAccountName, BatchAccountKey);


            

            using (BatchClient batchClient = BatchClient.Open(batchSharedKeyCredentials))
            {

                //Console.WriteLine("Creating pool [{0}]...", PoolId);
                //PoolCreation(batchClient, PoolId);
                //Console.WriteLine("Created pool [{0}]...", PoolId);


                //Console.WriteLine("Creating Job [{0}]...", JobId);
                //JobCreation(batchClient, JobId, PoolId);
                //Console.WriteLine("Created Job [{0}]...", JobId);

                //Console.WriteLine("Creating Task in Job [{0}]...", JobId);
                //TaskCreation(batchClient, JobId);
                //Console.WriteLine("Created Task in [{0}]...", JobId);

//              JobDeletion(batchClient, JobId);

            }
        }

        private static void JobDeletion(BatchClient batchClient, string jobId)
        {
            try
            {
                Console.WriteLine("Deleting the Job");

                batchClient.JobOperations.DeleteJob(jobId);

                Console.WriteLine("DELETED the Job");

            }
            catch (BatchException error)
            {
                Console.WriteLine(error.Message);
            }
        }

        private static void PoolCreation(BatchClient batchClient, string poolId)
        {
            try
            {
                ImageReference imageReference = new ImageReference(
                            publisher: "MicrosoftWindowsServer",
                            offer: "WindowsServer",
                            sku: "2016-datacenter",
                            version: "latest");

                VirtualMachineConfiguration virtualMachineConfiguration = new VirtualMachineConfiguration(
                    imageReference: imageReference,
                    nodeAgentSkuId: "batch.node.windows amd64");

                CloudPool cloudPool = batchClient.PoolOperations.CreatePool(poolId: poolId,
                    targetDedicatedComputeNodes: PoolNodeCount,
                    targetLowPriorityComputeNodes: 0,
                    virtualMachineSize: PoolVMSize,
                    virtualMachineConfiguration: virtualMachineConfiguration
                   );

                cloudPool.Commit();
            }

            catch (BatchException pool_error)
            {
                Console.WriteLine(pool_error.Message);
            }
        }


        private static void JobCreation(BatchClient batchClient, string jobId, string poolId)
        {
            try
            {
                CloudJob cloudJob = batchClient.JobOperations.CreateJob();
                cloudJob.Id = jobId;

                cloudJob.PoolInformation = new PoolInformation { PoolId = poolId };

                cloudJob.Commit();
            }

            catch (BatchException error)
            {
                Console.WriteLine(error.Message);
            }
        }

        private static void TaskCreation(BatchClient batchClient, string jobId)
        {

            try
            {
                Console.WriteLine("Creating the Task");

                string taskId = "demotask";
                string containerName = "input";
                string blobName = "sample.mp4";

                string storageaccountconnectionstr = "DefaultEndpointsProtocol=https;AccountName=msaz203storageacc;AccountKey=HQ+HAzor6k/CPtgmHSoGnaNhWys/kT854dOjYz/s/qSDdQRf61c6Mzw8TQ5sgDVPPZAPJF4UV4wGrE4KnOpw0Q==;EndpointSuffix=core.windows.net";

                CloudStorageAccount cloudStorageAccount = CloudStorageAccount.Parse(storageaccountconnectionstr);
                CloudBlobClient cloudBlobClient = cloudStorageAccount.CreateCloudBlobClient();

                CloudBlobContainer cloudBlobContainer = cloudBlobClient.GetContainerReference(containerName);

                CloudBlockBlob cloudBlockBlob = cloudBlobContainer.GetBlockBlobReference(blobName);

                Console.WriteLine("cloudBlockBlob.Uri: {0}", cloudBlockBlob.Uri);

                SharedAccessBlobPolicy sharedAccessBlobPolicy = new SharedAccessBlobPolicy
                {
                    SharedAccessExpiryTime = DateTime.UtcNow.AddHours(2),
                    Permissions = SharedAccessBlobPermissions.Read | SharedAccessBlobPermissions.List
                };

                string sasToken = cloudBlobContainer.GetSharedAccessSignature(sharedAccessBlobPolicy);
                string sasURL = String.Format("{0}{1}", cloudBlockBlob.Uri, sasToken);

                List<ResourceFile> resourceFiles = new List<ResourceFile>();

                Console.WriteLine("sasURL: {0}", sasURL);

                resourceFiles.Add(new ResourceFile(sasURL, blobName));

                string appPath = String.Format("%AZ_BATCH_APP_PACKAGE_{0}#{1}%", Packageid, Packageversion);
                string taskCommandLine = String.Format("cmd /c {0}\\ffmpeg.exe -i {1} -vn -acodec copy audio.aac", appPath, blobName);
                Console.WriteLine("taskCommandLine: {0}", taskCommandLine);

                CloudTask cloudTask = new CloudTask(taskId, taskCommandLine);
                cloudTask.ResourceFiles = resourceFiles;

                batchClient.JobOperations.AddTask(jobId, cloudTask);

            }
            catch (BatchException error)
            {
                Console.WriteLine(error.Message);
            }
        }

    }

}


