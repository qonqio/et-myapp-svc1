using Microsoft.ApplicationInsights;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace Contoso.Service1.FunctionHost.HealthProbes
{
    public class ReadinessProbe
    {
        private readonly TelemetryClient _telemetryClient;
        private readonly ILogger<ReadinessProbe> _logger;

        public ReadinessProbe(TelemetryClient telemetryClient, ILogger<ReadinessProbe> logger)
        {
            _telemetryClient = telemetryClient;
            _logger = logger;
        }

        [Function("health-ready")]
        public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "health/ready")] HttpRequest req)
        {
            var version = typeof(ReadinessProbe)?.Assembly?.GetName()?.Version?.ToString(fieldCount: 4);
            var model = new PingModel() { Answer = "Pong", Version = version };
            _logger.LogInformation($"READY {JsonSerializer.Serialize(model)}", _logger);
            _telemetryClient.TrackEvent("READY");
            return new JsonResult(model);
        }
    }
}