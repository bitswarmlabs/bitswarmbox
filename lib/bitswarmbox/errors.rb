module BitswarmBox
  # A collection of errors which can be raised by boxes.
  module Errors
    # Base error class for all other errors.
    class BitswarmBoxError < StandardError; end

    # Raised when a template is missing.
    class TemplateNotFoundError < BitswarmBoxError; end

    # Raised when a script is missing.
    class ScriptNotFoundError < BitswarmBoxError; end

    # Raised when an expected argument is missing.
    class MissingArgumentError < BitswarmBoxError; end

    # Raised when a build fails.
    class BuildRunError < BitswarmBoxError; end
  end
end
