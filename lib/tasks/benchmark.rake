# frozen_string_literal: true

class TestModel
  include ActiveModel::Model

  attr_accessor :name, :options, :expand, :filter
end

namespace :benchmark do
  desc "benchmark.bm"
  task bm: :environment do
    require "benchmark"
    require "action_controller/test_case"

    class BenchmarksController < ApplicationController; end
    controller_view = new_benchmark_controller.view_context

    n = 10_000
    model = TestModel.new

    Benchmark.bm do |benchmark|
      benchmark.report("ComponentFormBuilder") do
        n.times do
          controller_view.render("forms/form", model:, builder: ComponentFormBuilder)
        end
      end

      benchmark.report("FormBuilder") do
        n.times do
          controller_view.render("forms/form", model:)
        end
      end
    end
  end

  desc "benchmark.ips"
  task ips: :environment do
    require "benchmark/ips"
    require "action_controller/test_case"

    class BenchmarksController < ApplicationController; end
    controller_view = new_benchmark_controller.view_context
    model = TestModel.new

    Benchmark.ips do |x|
      x.time = 10
      x.warmup = 2

      x.report("ComponentFormBuilder") do
        controller_view.render("forms/form", model:, builder: ComponentFormBuilder)
      end

      x.report("FormBuilder") do
        controller_view.render("forms/form", model:)
      end

      x.compare!
    end
  end

  desc "benchmark.memory"
  task memory: :environment do
    require "benchmark/memory"
    require "action_controller/test_case"

    class BenchmarksController < ApplicationController; end
    controller_view = new_benchmark_controller.view_context
    model = TestModel.new

    Benchmark.memory do |x|
      x.report("ComponentFormBuilder") do
        controller_view.render("forms/form", model:, builder: ComponentFormBuilder)
      end

      x.report("FormBuilder") do
        controller_view.render("forms/form", model:)
      end

      x.compare!
    end
  end

  def new_benchmark_controller
    BenchmarksController.view_paths = [Rails.root.join("app/views").to_s]

    BenchmarksController.new.tap { |controller|
      controller.request = ActionDispatch::TestRequest.create
        .tap { |r| r.session = ActionController::TestSession.new }

      controller.extend(Rails.application.routes.url_helpers)
    }
  end
end
