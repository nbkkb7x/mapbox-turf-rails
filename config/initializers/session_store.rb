# Possible Temp Fix for InvalidAuthenticityToken Error
Rails.application.config.session_store :cookie_store, expire_after: 14.days