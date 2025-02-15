# Terraform AzureEventHub
	• Event Hub can handle massive data ingress, supporting millions of events per second. It is designed for high-throughput scenarios where you need to capture large-scale data streams in real-time.
	• Event Hub allows you to collect data from real-time sources (e.g., IoT devices, logs, videos, websites, mobile apps etc.) and push it to real-time analytics services like Azure Stream Analytics, Apache Kafka, or Azure Databricks.
	• Ingress (Incoming Data):
		• A single Throughput Unit provides 1 MB per second of ingress capacity.
		• This means your Event Hub can accept up to 1 MB of data per second for every Throughput Unit allocated.
	• Egress (Outgoing Data):
		• A single Throughput Unit also supports 2 MB per second of egress capacity.
This means that for every Throughput Unit, you can read or consume up to 2 MB of data per second from the Event Hub.


