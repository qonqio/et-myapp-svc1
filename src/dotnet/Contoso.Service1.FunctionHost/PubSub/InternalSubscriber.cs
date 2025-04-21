using Azure.Messaging;
using Microsoft.ApplicationInsights;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Contoso.Service1.FunctionHost.PubSub
{
    public class InternalSubscriber
    {
        private readonly TelemetryClient _telemetryClient;
        private readonly ILogger<InternalSubscriber> _logger;

        public InternalSubscriber(TelemetryClient telemetryClient, ILogger<InternalSubscriber> logger)
        {
            _telemetryClient = telemetryClient;
            _logger = logger;
        }

        [Function(nameof(InternalSubscriber))]
        public void GetEvents([EventGridTrigger] CloudEvent cloudEvent)
        {
            _logger.LogInformation("Event type: {type}, Event subject: {subject}", cloudEvent.Type, cloudEvent.Subject);
            _telemetryClient.TrackEvent("Event.ACK");
        }
    }
}