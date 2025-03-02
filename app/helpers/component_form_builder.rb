# frozen_string_literal: true

class ComponentFormBuilder < ViewComponent::Form::Builder
  # Instead of inheriting from ViewComponent::Form::Builder,
  # you can also inherit from ActionView::Helpers::FormBuilder
  # then include only the modules you need:

  # Provides `render_component` method and namespace management
  # include ViewComponent::Form::Renderer

  # Exposes a `validation_context` to your components
  # include ViewComponent::Form::ValidationContext

  # All standard Rails form helpers
  # include ViewComponent::Form::Helpers::Rails

  # Backports of Rails 7 form helpers (can be removed if you're running Rails >= 7)
  # include ViewComponent::Form::Helpers::Rails7Backports

  # Additional form helpers provided by ViewComponent::Form
  # include ViewComponent::Form::Helpers::Custom

  # Set the namespace you want to use for your own components
  # requires inheriting from ViewComponent::Form::Builder
  # or including ViewComponent::Form::Renderer
  namespace "Form"
end
