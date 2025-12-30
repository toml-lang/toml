# Philosophical Audit of TOML's Common Sense Foundations

## Introduction

This document presents a philosophical audit of the TOML (Tom's Obvious, Minimal Language) specification. It examines the tacit, self-evident principles—the "common sense" axioms—that underpin the design of TOML as a configuration file format. The audit draws on the philosophies of Thomas Reid and G.E. Moore to analyze how these principles function as foundational beliefs and how they might be challenged. This work originates from a broader inquiry into the intersection of common sense and structured knowledge (see [Issue #???](https://github.com/toml-lang/toml/issues/???)), and aims to enrich the community's understanding of the standard's philosophical underpinnings.

## Identified Common Sense Principles

The following principles are either explicitly stated in the TOML specification or implicitly assumed as obvious or natural. Quotations are from the [official specification](https://github.com/toml-lang/toml/blob/main/toml.md) (commit `bcbbd1c1f03473ffe97b8bf26a0fc945efe2b4a1`).

1. **Obvious Semantics**  
   > "TOML aims to be a minimal configuration file format that's easy to read due to obvious semantics."  
   Assumption: The meaning of a configuration file can be transparent and self‑evident to any reader.

2. **Hash‑Table Mapping**  
   > "TOML is designed to map unambiguously to a hash table."  
   Assumption: Configuration data naturally and universally fits a key‑value (hash‑table) model.

3. **Simplicity as a Virtue**  
   The specification repeatedly emphasizes minimalism, human readability, and ease of parsing.  
   Assumption: Simpler is always better; complexity is to be avoided.

4. **Case Sensitivity**  
   > "TOML is case‑sensitive."  
   Assumption: Distinguishing between `key` and `Key` is the natural default for a text‑based format.

5. **UTF‑8 as Universal Encoding**  
   > "A TOML file must be a valid UTF‑8 encoded Unicode document."  
   Assumption: UTF‑8 is the obvious, universal choice for text representation.

6. **Key‑Uniqueness**  
   > "Defining a key multiple times is invalid."  
   Assumption: Duplication of keys is inherently wrong and leads to ambiguity.

7. **Line‑Oriented Structure**  
   > "There must be a newline (or EOF) after a key/value pair."  
   Assumption: Configuration is best organized line‑by‑line, following the tradition of plain‑text files.

8. **Closed Set of Types**  
   The specification enumerates a fixed list of value types (strings, integers, floats, booleans, dates, arrays, inline tables).  
   Assumption: These types are sufficient for all configuration needs.

9. **Ordered Arrays**  
   > "Arrays are ordered values surrounded by square brackets."  
   Assumption: The order of elements in a list is meaningful and must be preserved.

10. **Hierarchical Tables via Headers**  
    Tables are defined by headers (`[table]`) and can be nested.  
    Assumption: Hierarchical organization is the most intuitive way to group related configuration items.

11. **No Inheritance or Overriding**  
    The standard explicitly forbids redefining keys and does not provide a built‑in mechanism for inheritance or environment‑specific overrides.  
    Assumption: Configuration should be static and self‑contained; derivation and context‑sensitive variations belong outside the format.

12. **Human‑Readable Dates (RFC 3339)**  
    Date‑time values must follow RFC 3339.  
    Assumption: This particular date‑time representation is the most obvious and widely understood.

## Reid & Moore Analysis

### Thomas Reid’s “Principles of Common Sense”

Thomas Reid argued that certain beliefs are “principles of common sense”—self‑evident truths that are foundational and undeniable. They are not derived from reason but are immediately apprehended by all rational beings. Many of TOML’s design choices can be viewed as such principles:

- **“A key must have a value.”** This is treated as axiomatic; an unspecified value is simply invalid.
- **“Data should be consistent.”** The prohibition on duplicate keys and the requirement that tables not be redefined reflect a deep‑seated belief that consistency is a prerequisite for unambiguous interpretation.
- **“Human readability is a good.”** The emphasis on obvious semantics, minimalism, and plain‑text formatting rests on the common‑sense intuition that configuration files are meant to be read and edited by people.

For Reid, these principles are not up for debate; they are the “bedrock” upon which the rest of the specification is built. To question them would be to question the very possibility of a usable configuration format.

### G.E. Moore’s “Common Sense Defense”

G.E. Moore famously defended common‑sense beliefs against radical skepticism by pointing to everyday certainties (e.g., “Here is a hand”). TOML’s design appeals to a similar kind of common‑sense certainty:

- **“Everyone knows that configuration files should be easy to read.”** The appeal to “obvious semantics” and “minimalism” functions like Moore’s “here is a hand”—it is presented as something so plainly true that it needs no further justification.
- **“Everyone knows that duplication is bad.”** The rule against duplicate keys is defended by appealing to the universal experience that duplicate definitions cause confusion.
- **“Everyone knows that simplicity is better than complexity.”** The specification assumes that this sentiment is shared by all reasonable practitioners.

Moore’s strategy is to deflect philosophical doubt by insisting on the obviousness of everyday beliefs. In the same way, TOML deflects potential criticism of its design by appealing to what “everyone knows” about good data practice.

## A Critical Challenge

While common‑sense principles provide a sturdy foundation, they are not infallible. Their very obviousness can blind us to edge cases, cultural variations, and philosophical paradoxes. Consider one particular principle:

**Principle Challenged: “Keys must be unique.”**

### The Limitation

The uniqueness rule assumes that each piece of configuration data has a single, definitive value. However, real‑world configuration often involves **inheritance** or **environment‑specific overrides**. For example, a base configuration might define a database host, while a development environment overrides only the hostname. In TOML, this must be accomplished either by duplicating entire sections (violating DRY) or by moving the variation outside the format (e.g., using separate files or templating). The common‑sense rule “no duplicate keys” thereby limits the expressiveness of the format for a legitimate class of use‑cases.

### Philosophical Paradox: The Ship of Theseus Applied to Data

The Ship of Theseus asks whether an object that has all its components replaced remains the same object. Applied to configuration:

> If a TOML file is gradually transformed—keys renamed, values changed, sections added or removed—at what point does it cease to be the “same” configuration?

TOML’s static, snapshot‑oriented model offers no built‑in mechanism for tracking identity across changes. The common‑sense assumption that a configuration file is simply the sum of its present key‑value pairs ignores the dynamic, evolutionary nature of many configuration scenarios (e.g., version‑controlled configuration that evolves over time).

### Cultural Context

The date‑time format (RFC 3339) is a Western‑centric convention. While it is a standard in computing, its “obviousness” is not universal. Other cultures might represent dates in entirely different ways (e.g., lunar calendars, ordinal day‑of‑year). By enshrining one particular representation, TOML implicitly privileges a specific cultural perspective—a limitation that common‑sense design often overlooks.

## Conclusion

Examining TOML through the lens of common‑sense philosophy reveals both its strengths and its blind spots. The principles identified above provide a coherent, intuitive foundation that has contributed to TOML’s widespread adoption. At the same time, a critical audit highlights areas where these principles may be too rigid or culturally specific.

This analysis does not propose changes to the TOML specification; rather, it aims to foster a deeper awareness of the tacit assumptions embedded in our tools. By making the “obvious” explicit, we can better understand why the standard works the way it does, anticipate its limitations, and make more informed choices when using or extending it.

In the spirit of open‑source philosophy, this document is offered as a contribution to the collective understanding of TOML—a “conceptual patch” that complements the technical specification with a layer of philosophical reflection.

---

*This audit was prepared as part of a philosophical inquiry into common‑sense assumptions in open standards. Feedback, discussion, and further contributions are welcome.*