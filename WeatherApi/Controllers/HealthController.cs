using System;
using Microsoft.AspNetCore.Mvc;

namespace WeatherApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HealthController : ControllerBase
    {
        [HttpGet("healthy")]
        public ActionResult GetHealthy()
        {
            return Ok("ok");
        }

        [HttpGet("unhealthy")]
        public ActionResult GetUnhealthy()
        {
            throw new Exception("Error!");
        }
    }
}