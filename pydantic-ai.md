# pydantic ai

Control flow is:

1. agent calls llm with the current message history, and the llm determines the next step by outputting structured json (`ToolCallPart`) together with text (`TextPart`), or just text
1. if the llm returns the agent's `output_type` (represented as the [`final_result` tool](https://github.com/pydantic/pydantic-ai/blob/1def7df728a5e757ceb16797a8b608e00da70982/tests/models/test_bedrock.py#L107)), the agent will end and return this as its output. The output type can be a `str` (ie: just text) or a structured type.
1. if there's a validation and other error, [retry the previous step](https://ai.pydantic.dev/api/messages/#pydantic_ai.messages.RetryPromptPart)
1. the agent executes the tool call, the response is a `ToolReturnPart`
1. message history is updated with output from previous steps and we repeat

Similar to [this](https://news.ycombinator.com/item?id=42299464).

- validates responses from LLM using pydantic
- type-safe API
- async
- streaming response
- multiple models, using tool calling apis eg: [Bedrock Converse API](https://docs.aws.amazon.com/bedrock/latest/userguide/tool-use-inference-call.html)
- [evals](https://ai.pydantic.dev/evals/#parallel-evaluation) using llm-as-a-judge (see also [examples](https://github.com/pydantic/pydantic-ai/blob/main/examples/pydantic_ai_examples/evals/example_04_compare_models.py))
- otel observability via logfire
- [unit test support](https://ai.pydantic.dev/testing/)
- [persisting state of graph](https://ai.pydantic.dev/graph/#state-persistence) (durable execution)

## known issues

- [Prompt caching support #138](https://github.com/pydantic/pydantic-ai/issues/138)
- [Interrupt before making a tool call (human in the loop) #642](https://github.com/pydantic/pydantic-ai/issues/642)
- [Guardrails #1197](https://github.com/pydantic/pydantic-ai/issues/1197)
- [Improve "Ergonomics" of Graph Streaming #1452](https://github.com/pydantic/pydantic-ai/issues/1452)
- [Parallel node execution in Graphs #704](https://github.com/pydantic/pydantic-ai/issues/704)

## HITL

> I implemented this HITL using FullStatePersistence and graph.iter:
> async with run_graph as run:
>
> ```
>     while True:
>         node = await run.next()
>         if isinstance(node, WaitForHumanInput):
>             await run.next()
>             break
> ```
>
> where `run_graph` is either:
>
> ```
> graph.iter(EntryNode(), state=state, deps=deps, persistence=persistence)
> ``
> when starting a new iteration, or:
> ``
> graph.iter_from_persistence(
>             persistence,
>             deps=deps,
>         )
> ```
>
> If returning with an already existing persistence json.

## model retry

ModelRetry has a circuit breaker that only allows max_retries errors per tool before it aborts the loop by raising an UnexpectedModelBehavior (see [here](https://github.com/pydantic/pydantic-ai/blob/8f83407d870475dfc1885fa5119024dc2ffb44ab/pydantic_ai_slim/pydantic_ai/tools.py#L417)).

If it doesn’t abort, the exception message is converted to a [RetryPromptPart](https://ai.pydantic.dev/api/messages/#pydantic_ai.messages.RetryPromptPart) and sent to the model when with "Fix the errors and try again." [appended to the message](https://github.com/pydantic/pydantic-ai/blob/08cf5dd33c21d477895a8437c05afb9742e9b25d/pydantic_ai_slim/pydantic_ai/messages.py#L442).

If the goal is for the LLM to exit the loop and respond nicely you need to return an error result from the tool. And in the agent instructions tell it to convert any error results into a nice user message.
