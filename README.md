# RealPage Calculator Project (RPC)
## A Ruby command-line reverse polish notation (RPN) calculator
Original specifications may be found [here][specs].

## In This Document

+ [Solution Overview](#solution-overview)
+ [Technical/Architectural Reasoning](#technicalarchitectural-reasoning)
+ [Technical/Architectural Reflections](#technicalarchitectural-reflections)
+ [Creating a New Interface](#creating-a-new-interface)

## Solution Overview
The RPC project consists of: 
+ Two _primary class categories_.
+ Several _secondary class categories_ whose sole purpose is to facilitate the functionality of the _primary classes_.
+ A series of _support classes/modules_ that assist with the overall funcionality of this project.
+ _Configuration files_ used to dynamically configure this project.
+ An _executable command-line scripts_ that allows Users to run and interact with a particular _Calculator_ in a UNIX-like CLI.

### Primary class categories

| Primary Class Category        | Example Class | High-Level Function |
|-------------:|:-------------|:------------------|
| IO Interfaces | `RealPage::Calculator::IOInterface` `RealPage::Calculator::ConsoleInterface`  | _IO Interface_ class objects (_IO Interface_) are responsible for the communication between the stream (input, output, error) and the _Calculator Service_ class object (_Calculator Service_) and vise versa. |
| Calculator Services | `RealPage::Calculator::CalculatorService` `RealPage::Calculator::RPNCalculatorService`  | _Calculator Services_ are responsible for computing the input received from the _IO Interface_ and returning the result and/or any errors encountered back to the _IO Interface_.|

### Secondary class categories

| Secondary Class Category        | Example Class | High-Level Function |
|-------------:|:-------------|:------------------|
| Calculator Results | `RealPage::Calculator::CalculatorResults`  | _CalculatorResult_ class objects (_CalculatorResult_) are returned to the _IO Interace_ as a result of a _Calculator Service_ request initiated by the _IO Interface_. The _CalculatorResult_ contains the computed result and/or any error that may have been encountered during the request. |
| Input Parsers | `RealPage::Calculator::InputParser` `RealPage::Calculator::RPNInputParser`  | _InputParser_ class objects (_InputParser_) are used by _Calculator Services_ and responsible for parsing input received from an _IO Interface_ into a format suitable for processing by the _Calculator Service_. |
| Input Tokens | `RealPage::Calculator::InputToken`  | _InputToken_ class objects (_InputToken_) represent an individual, space delimited token received from the input stream. _InputToken_ is responsible for identifying the _nature_ and _type_ of the token it encapsulates. For example, _InputToken_ identifies the following token types: _operators_, _operands_ and _commands_; it also identifies whether or not a token is _valid_. |

### Support classes/modules

| Support Class/Module | High-Level Function |
|:-------------|:------------------|
| `RealPage::Calculator::Configuration`  | The _Configuration_ Singleton object (_Configuration_) is responsible for loading the _/calculator/config/calculator_service_config.yml_ file and providing a single(ton) interface to configuration settings user by _Calculator Services_. Configuration settings such as valid _operators_, _commands_ (i.e. as _quit_, _view stack_, _clear stack_) and _console_interface_options_ are made available through the _Configuration_ Singleton. |
| `RealPage::Calculator::I18nTranslator`  | The _i18n Tranclator_ Singleton object (_i18n Translator_) is responsible for loading the /configuration/config/i18n.yml file and providing a single(ton) interface for _translation_ services used by _IO Interfaces_. |
| `RealPage::Calculator::InterfaceNotReadyError` `RealPage::Calculator::MustOverrideError`  | The _Error_ class objects (_Errors_) are used throughout the RPC project wherever a custom error needs to be raised.|
| `RealPage::Calculator::Errors`  | The _Error Support_ module (_Error Support_) defines errors in the form of _Hash_ values. When the _Calculator Service_ encounters an error, a _CalculatorResult_ object is created and the _Error Support_ error is embedded in the _CalculatorResult_ object and sent to the _IO Interface_. The _Error Support_ error Hash embedded in the _CalculatorResult_ object is then used by the _IO Interface_ as input to the _i18n Translator_ ({key: :key, scope: :scope}) to return a locale specific error message to the output stream. |
| `RealPage::Calculator::ArrayExtension`  | The _Array Extensions_ extensions (_Array Extensions_) add convenience functionality to the Ruby _Array_ class in support of _InputToken_ array processing. |
| `RealPage::Calculator::ObjectExtension`  | The _Object Extensions_ extensions (_Object Extensions_) add convenience functionality to the Ruby _Object_ class in support of _InputToken_ array processing. |

### Configuration files

| File        | High-Level Purpose |
|-------------:|:------------------|
| `/calculator/config/calculator.yml`  | The _Calculator Configuration_ file is used to configure _operators_ and command-line _commands_ that will be acknowledged by the _CalculatorServices_ and _IO Interfaces_, as well as options to configure specific _IO Interface_ behavior. |
| `/calculator/config/i18n.yml`  | The _i18n Configuration_ file provides locale-specific translation entries in the form of _key/scope pairs_ used by the _i18n Translator_ |

### Executable command-line scripts

| Script        | Type | Purpose |
|-------------:|:------------------|:------------------|
| `/calculator/console_rpn_calculator.rb`  | Ruby | The _Console RPN Calculator_ file is an _executable Ruby script_ that Users can use to run and interact with the RPN calculator in a UNIX-like CLI. |

## Technical/Architectural Reasoning

According to the [specification][specs], the RPC project was to create a _command-line, Reverse Polish Notation calculator for people who are comfortable with UNIX-like CLI utilities_. The specification also dictated that the initial project installment must implement the four basic calculator operators (+, -, /, *) and be designed in such a way as to allow for additional operators and interfaces (WebSocket, file or TCP Socket) to be added in the future. In addition to these, I took the liberty of presuming the possibility of _additional calculator types_ as well. Consequently, I sought to design this RPC project in such a way as to be (among other things): 
+ _Configurable_ (additional operators)
+ _Extensible_ (additional _IO Interfaces_, _Calculator Service_ types) 
+ _DRY_
+ _Testable_ 

From an _architectural perspective_, the RPC project consists of a series of what will be referred to (arbitrarily) as:
+ _Primary class categories_
+ _Secondary class categories_
+ _Support classes/modules_ 
+ _Executable command-line scripts_
 
The remainder of this section will give an overview of each, as well as the technical/architectural reasoning behind the same.

### Primary Class Categories
#### Overview
_Primary class categories_ include _IO Interfaces_ and _Calculator Services_. Classes that derive from `RealPage::Calculator::IOInterface` and `RealPage::Calculator::CalculatorService`, respectfully, fall into these categories. _IO Interfaces_ and _Calculator Services_ are considered _Primary classes_ because these are the categories of classes Developers _and_ Users will interact with most often. 

The _IO Interface_ acts as a liaison between the _Calculator Service_ and the particular stream the _IO Interface_ represents. Consequently, the _IO Interface_ is also responsible for the format (plain text, json, xml, etc.) and translation any output sent to the output stream using i18n. The _Calculator Service_ is a service responsible for accepting input from, and returning a result (computation or error) to, the _IO Interface_. Consequently, the _Calculator Service_ is responsible for manipulating the raw input received from the _IO Interface_ into a format specific to its own needs, and returning the raw result (_CalculatorResult_ object) back to the _IO Interface_. 

### Reasoning

The _IO Interface_ and _Calculator Service_ are interdependent; therefore, they need to communicate with eachother. However, the _IO Interface_ and _Calculator Service_ have _distinct concerns_. As a result, the decision was made to create _two_ categories of classes - each concerned solely with its own, distinct, funcionality - maintaining a clear _separation of concern_. In addition to this, the decision was made to require that a `RealPage::Calculator::CalculatorService` object be provided when instantiating a `RealPage::Calculator::IOInterface` object. This _losely coupled relationship_ (as opposed to _Composition_) makes for a more _extensible_, _testable_, and potentially DRY framework, and opens up the ability for future non-RPN-based _Calculator Services_ to be implemented using existing _IO Interfaces_. Similar rationale and implementation can be witnessed between the _Calculator Service_ -> _Input Parser_ relationship (i.e. `RealPage::Calculator::CalculatorService`, `RealPage::Calculator::InputParser`)

### Secondary Class Categories
#### Overview
_Secondary class categories_ include _Calculator Results_, _Input Parsers_ and _Input Tokens_. Classes and those that derive from `RealPage::Calculator::CalculatorResult`, `RealPage::Calculator::InputParser` and `RealPage::Calculator::InputToken`, respectfully, fall into these categories. These are considered _secondary class categories_ because their sole purpose is to facilitate the functionality of the _primary classes_.

A _Calculator Result_ is returned via notification from a _Calculator Service_ to an _IO Service_ in response to a _Calculator Service_ request (e.g. `RealPage::Calculator::CalculatorService#compute`). A _Calculator Result_ object encapsulates a _Calculator Service_ computation or error encountered along with the offending token. _Calculator Result_ provides a standard container class for communicating results from the _Calculator Service_ to the _IO Interface_.

_Input Parsers_ are used by _Calculator Services_. A `RealPage::Calculator::CalculatorService`, in fact, cannot be instantiated without providing an `RealPage::Calculator::InputParser`. _Input Parsers_ are responsible for parsing input received from an _IO Interface_ into a format suitable for processing by the _Calculator Service_. 

_Input Tokens_ are used by classes derived from `RealPage::Calculator::InputParser` and represent an individual, space delimited token received from the input stream. _Input Token_ is responsible for identifying the _nature_ and _type_ of the token it encapsulates. For example, _Input Token_ identifies the following token types: _operators_, _operands_ and _commands_; it also identifies whether or not a token is _valid_.

### Reasoning

Encapsulating the result returned from a _Calculator Service_ (in a _Calculator Result_ object)  enforces a standard in the way _Calculator Services_ and _IO Interfaces_ exchange _Calculator Service_ results. _Calculator Result_ provides rudimentary methods to retrieve computed results and identify/retrieve errors when the occur (_single responsibility_). _Calculator Result_ can be easily extended to provide additional information or functionality should it be required by a future _Calculator Service_ or _IO Interface_. Finally, in addition to providing _extensibility_, _Calculator Result_ classes are _testable_, and its enforced use helps to maintain the DRY principle.

_Calculator Services_ have the _single responsibility_ of computing. Likewise, _Input Parsers_ have the _single responsibility_ of parsing input received from an _IO Interface_ into a format suitable for processing by the _Calculator Service_. _Input Parsers_ relieve the _Calculator Service_ of this burden by eliminating this concern. _Input Parsers_ help keep things DRY as they may be shared between _Calculator Services_ or _extended_. In addition to this, _Input Parsers_ provide better, isolated _testability_. 



## Technical/Architectural Reflections
## Creating a New Interface
## Script Execution

   [specs]: <https://gist.github.com/joedean/078a62b9ec03b38dfc519b3a5f168b07>
