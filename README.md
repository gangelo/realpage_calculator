# RealPage Calculator Project (RPC)
## A Ruby command-line reverse polish notation (RPN) calculator
Original specifications may be found [here][specs].

## In This Document

[Solution Overview](#solution-overview)
[Technical/Architectural Reasoning](#technical-architectural-reasoning)
[Creating a New Interface](#creating-a-new-interface)

## Solution Overview
The RPC project consists of: 
+ Two _primary class categories_.
+ Several _secondary class categories_ whose sole purpose is to facilitate the functionality of the _primary classes_.
+ A series of _miscellaneous classes/modules_ that support the overall funcionality of this project.
+ _Configuration files_ used to dynamically configure this project.
+ An _executable command-line Ruby script_ that allows Users to run and interact with the RPN calculator in a UNIX-like CLI.

### Primary class categories

| Primary Class Category        | Example Class | High-Level Function |
|-------------:|:-------------|:------------------|
| IO Interfaces | `RealPage::Calculator::IOInterface` `RealPage::Calculator::ConsoleInterface`  | _IO Interface_ class objects (_IO Interface_) are responsible for the communication between the stream (input, output, error) and the _Calculator Service_ class object (_Calculator Service_) and vise versa. |
| Calculator Services | `RealPage::Calculator::CalculatorService` `RealPage::Calculator::RPNCalculatorService`  | _Calculator Services_ are responsible for computing the input received from the _IO Interface_ and returning the result and/or any errors encountered back to the _IO Interface_.|

### Secondary class categories

| Secondary Class Category        | Example Class | High-Level Function |
|-------------:|:-------------|:------------------|
| Calculator Results | `RealPage::Calculator::CalculatorResults`  | _CalculatorResult_ class objects (_CalclulatorResult_) are returned to the _IO Interace_ as a result of a _Calculator Service_ request initiated by the _IO Interface_. The _CalculatorResult_ contains the computed result and/or any error that may have been encountered during the request. |
| Input Parsers | `RealPage::Calculator::InputParser` `RealPage::Calculator::RPNInputParser`  | _InputParser_ class objects (_InputParser_) are used by _Calculator Services_ and responsible for parsing input received from an _IO Interface_ into a format suitable for processing by the _Calculator Service_. |
| Input Tokens | `RealPage::Calculator::InputToken`  | _InputToken_ class objects (_InputToken_) represent an individual, space delimited token received from the input stream. _InputToken_ is responsible for identifying the _nature_ and _type_ of the token it encapsulates. For example, _InputToken_ identifies the following token types: _operators_, _operands_ and _commands_; it also identifies whether or not a token is _valid_. |

### Miscellaneous classes/modules

| Class/Module | High-Level Function |
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

### Executable command-line Ruby script

| Script        | Purpose |
|-------------:|:------------------|
| `/calculator/console_rpn_calculator.rb`  | The _Console RPN Calculator_ file is an _executable Ruby script_ that Users can use to run and interact with the RPN calculator in a UNIX-like CLI. |

## Technical/Architectural Reasoning
## Technical/Architectural Musings
## Creating a New Interface
## Script Execution

   [specs]: <https://gist.github.com/joedean/078a62b9ec03b38dfc519b3a5f168b07>
