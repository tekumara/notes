# Good LLM Tool Design

Suggestions for designing tools for an LLM or agent.

## The task

During tool or [function calling](https://platform.openai.com/docs/guides/function-calling?api-mode=chat), an LLM must decide which tool to select, extract the right parameter values, and interpret the response — with nothing to go on but the tool's name, a short description, a list of parameters and the response.

Every ambiguity in a tool's name, parameters, or response is inference work the model has to do — and a chance to get it wrong. This doc covers how to design tools that work well with an LLM or agent.

## Tool Design Is API Design, Optimised For an LLM

All the usual advice about good API design applies to tool design. What is good for human understanding is usually also good for an LLM. But tool design goes further. Tools are an optimised interface for consumption by a LLM that has no context beyond its general knowledge, the tool definition and its output.

The best tools do these things well:

- they map cleanly to user intent
- they provide the right amount of context and steering at the point of use
- they remove ambiguity

Which reduces errors and help an agent reach it's goal quicker. More detail below.

## Design Around User Intent

Align tools to user intent or "things users want to do" rather than backend resources.

It is easier for the model to map:

- "show me overdue invoices"
- "find active contacts"
- "summarise spending this month"

to tools shaped around those tasks than to generic resource-centric endpoints.

## Make Wrong Calls Hard

### Use distinct names

Avoid similar names and concepts. The more distinct and focused a tool is, the easier it is for the model to choose the right one.

Semantically close concepts can be confused with each other, for example:

- invoices vs bills
- contacts vs clients

### Do not allow invalid states to be expressed

If the system only supports a small set of valid choices, encode that directly.

Bad:

- `start_date`
- `end_date`

when only "this month" and "last month" are valid

Better:

- `date_range: "this_month" | "last_month"`

The model will try invalid combinations if the schema permits them.

## Make Parameters Easy To Infer Correctly

### Keep parameters simple

Simple is better:

- fewer parameters
- fewer optional combinations
- one level of nesting at most

Every extra field is another chance for the model to make the wrong call. See also [Hyrum’s Law](https://www.hyrumslaw.com/).

### Parameter names matter

Even with minimal documentation, the model will often try to infer usage from parameter names alone.

Names should be explicit, concrete, and hard to misread.

### Use values that match the user's language

Values should be intuitive and map directly to concepts users actually ask for. The less translation work the model has to do between what the user says and your schema, the better.

Example 1: "show my active contacts"

Bad:

- `status = 0` means active
- `status = 1` means inactive

Better:

- `status = "active" | "inactive"`

Example 2: "show my overdue invoices"

Bad:

- invoice status = authorised
- due date = before today

Better:

- `payment_state = "overdue"`

ie: make that easy to express directly rather than forcing the model to infer it from lower-level fields.

## Prefer self-explanatory responses

Response payloads matter just as much as request schemas. Smaller response payloads are better.

The model uses response field names and structure to:

- understand what happened
- decide whether the result answers the user
- ground its response
- choose a sensible next action

Response payloads should be self-explanatory. Consider this data model:

```python
class FinancialMetric(BaseModel):
    """Financial metric with value and comparison"""

    value: float
    comparison: float | None = None
    percentage_change: float | None = None
```

It doesn't say what `comparison` refers to. Are we comparing against last week, month, year? This also makes grounding impossible — if the model claims "metric is $200 this year compared to $100 last year", how do we validate that when we have a value and comparison but no idea what time periods they refer to?

Better:

```python
class FinancialMetric(BaseModel):
    current_value: float
    current_period: str
    comparison_value: float | None = None
    comparison_period: str | None = None
    percentage_change: float | None = None
```

Now both humans and models can reason about the output and validate claims against it.

## Design Errors For Recovery

Validation and error messages should help the model self-correct.

[Good errors](https://dev.to/stripe/designing-apis-for-humans-error-messages-94p) explain:

- what failed
- why it failed
- which parameter was wrong
- what valid values look like
- how to retry successfully

Good errors create a recovery path that let the agent try again.

## Prefer Simple Interaction Patterns

Favour simple, single-step interactions over multi-step call chains where possible.

Each additional call introduces more opportunities for:

- choosing the wrong tool
- passing the wrong argument
- losing context between steps
- compounding small mistakes

If a user task naturally spans multiple backend calls, it is often better to hide that complexity behind one model-friendly tool.

## Steering Matters

A lot of tool design is really about steering.

The model performs better when the tool surface includes the guidance needed to choose the right tool, use it correctly, and decide what to do next. Think "does the model have enough steering to choose and use it well?"

That steering can live in:

- the tool description
- parameter descriptions and examples
- constraints and defaults
- error messages
- the response payload

For example, the JAX `update_invoice_tool` (see [code here](https://github.com/xero-internal/dt-genie-model/blob/07bba4eab00a5c53d3fb4d377c470498a1865c18/genie_v2/tools/implementations/update_invoice.py#L81)) does not just describe its input fields. Its tool description explicitly tells the model what to do before calling it:

- if a new line item looks like a product or item code, call `search_inventory_items` first
- if that search returns 0 results, use the text as the line item description
- if it returns 1 result, use that item's `inventory_item_id`
- if it returns multiple results, ask the user to disambiguate

That is steering embedded in the tool description, but the same pattern can also live in the response payload conditioned on the response. A response can contain not just raw data, but signals about what follow-up actions are valid, what ambiguity remains, or what the model should do next.

## Checklist

Before exposing a tool to an LLM, ask:

- Can the model map common user requests directly to this tool?
- Can the schema express invalid or contradictory states?
- Are parameter names and values obvious without extra interpretation?
- Have all unnecessary parameters been removed?
- Has the response payload been stripped down to what the model actually needs?
- Does the response clearly explain what the data means?
- Will errors help the model retry correctly?
- Could multiple backend calls be collapsed into one simpler interaction?
- Is there enough steering in the tool description, the response payload, or both?
- Does the model have enough context at selection time to choose well?

## References

- [Designing Tool Interfaces for LLM Interaction](https://apxml.com/courses/building-advanced-llm-agent-tools/chapter-1-llm-agent-tooling-foundations/designing-tool-interfaces)
- [LLM-Friendly API Design](https://apxml.com/courses/building-advanced-llm-agent-tools/chapter-1-llm-agent-tooling-foundations/designing-tool-interfaces)
- [Context Management and MCP](https://cra.mr/context-management-and-mcp)
