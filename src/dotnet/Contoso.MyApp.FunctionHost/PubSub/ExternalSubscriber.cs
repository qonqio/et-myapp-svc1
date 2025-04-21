using Azure.Messaging;
using Microsoft.ApplicationInsights;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Contoso.MyApp.FunctionHost.PubSub
{
    public class ExternalSubscriber
    {
        private readonly TelemetryClient _telemetryClient;
        private readonly ILogger<InternalSubscriber> _logger;

        public ExternalSubscriber(TelemetryClient telemetryClient, ILogger<InternalSubscriber> logger)
        {
            _telemetryClient = telemetryClient;
            _logger = logger;
        }

        [Function(nameof(ExternalSubscriber))]
        public void GetEvents([EventGridTrigger] CloudEvent cloudEvent)
        {
            _logger.LogInformation("Event type: {type}, Event subject: {subject}", cloudEvent.Type, cloudEvent.Subject);
            _telemetryClient.TrackEvent("Event.ACK");
        }
    }
}
