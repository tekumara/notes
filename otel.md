# otel

| Component      | Description                                                                                                     | Example/Type                        |
| -------------- | --------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| TracerProvider | Holds configuration, manages tracers, registers span processors, and integrates exporters.                      | Application-wide singleton instance |
| SpanProcessor  | Receives span lifecycle events from TracerProvider, processes, batches (optionally), and forwards to exporters. | Batch or Simple span processor      |
| SpanExporter   | Consumes the final, processed span data and exports it to a backend or service.                                 | OTLP, Jaeger, or Zipkin exporter    |

```
Span (created by Tracer)
    ↓
SpanProcessor (e.g. BatchSpanProcessor)
    ↓
SpanExporter (e.g. OTLPExporter)
    ↓
External Backend (e.g. Jaeger)
```
