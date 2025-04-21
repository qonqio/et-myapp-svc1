using Azure.Messaging.EventGrid;
using Azure;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Azure.Identity;
using Microsoft.Extensions.Configuration;
using Azure.Messaging;
using Azure.Core.Serialization;
using System.Text.Json;
using Microsoft.ApplicationInsights;

namespace Contoso.MyApp.FunctionHost.PubSub
{
    public class InternalPublisher
    {
        private readonly TelemetryClient _telemetryClient;
        private readonly ILogger<InternalPublisher> _logger;
        private readonly IConfiguration _configuration;

        public InternalPublisher(TelemetryClient telemetryClient, ILogger<InternalPublisher> logger, IConfiguration configuration)
        {
            _telemetryClient = telemetryClient;
            _logger = logger;
            _configuration = configuration;
        }

        [Function(nameof(InternalPublisher))]
        public async Task<IActionResult> SendEvent([HttpTrigger(AuthorizationLevel.Function, "post")] HttpRequest req)
        {
            var managedIdentityClientId = _configuration["FUNCTION_MANAGED_IDENTITY"];
            var topicEndpoint = _configuration["EVENTGRID_INTERNAL_ENDPOINT"];
            ManagedIdentityCredential managedIdentityCredential = new ManagedIdentityCredential(managedIdentityClientId);
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            EventGridPublisherClient client = new EventGridPublisherClient(new Uri(topicEndpoint), managedIdentityCredential);

            var eventSource = "/cloudevents/example/source";
            var eventType = "Example.EventType";
            var payload = new PingModel() { Version = "EVG", Answer = "ACK" };

            var event1 = new CloudEvent(eventSource, eventType, payload);

            List<CloudEvent> eventsList = new List<CloudEvent>
            {
                event1
            };

            var funcResponse = "Message Sent";
            var eventGridResponse = await client.SendEventsAsync(eventsList);
            if (eventGridResponse.Status != 200)
            {
                _logger.LogError("Unable to publish eventgrid event");
                funcResponse = "Message not sent";
            }

            _telemetryClient.TrackEvent("Event");

            return new OkObjectResult(funcResponse);
        }
    }
}