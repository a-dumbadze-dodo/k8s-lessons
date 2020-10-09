using System;
using Microsoft.AspNetCore.Mvc;

namespace WeatherApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string StaticId = Guid.NewGuid().ToString();
        private static readonly string CreationDateTime = DateTime.Now.ToString();

        [HttpGet]
        public WeatherForecast Get()
        {
            var rng = new Random();
            return new WeatherForecast
            {
                ExecutionTime = DateTime.Now,
                RandomGuid = Guid.NewGuid().ToString(),
                StaticGuid = StaticId,
                CreationDateTime = CreationDateTime
            };
        }
    }
}
