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
    public class LivenessProbe
    {
        private readonly ILogger<LivenessProbe> _logger;

        public LivenessProbe(ILogger<LivenessProbe> logger)
        {
            _logger = logger;
        }

        [Function("health-live")]
        public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "health/live")] HttpRequest req)
        {
            var version = typeof(LivenessProbe)?.Assembly?.GetName()?.Version?.ToString(fieldCount: 4);
            var model = new PingModel() { Answer = "Pong", Version = version };
            _logger.LogInformation($"LIVE {JsonSerializer.Serialize(model)}", _logger);
            return new JsonResult(model);
        }
    }
}