class ApplicationError(Exception):
    """Base class for application-level failures."""


class ConfigurationError(ApplicationError):
    """Raised when the backend is misconfigured."""


class InvalidModelResponseError(ApplicationError):
    """Raised when an LLM returns an empty or unusable response."""


class UpstreamServiceError(ApplicationError):
    """Raised when an upstream provider request fails."""
