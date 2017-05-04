defmodule LknPrelude.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :lkn_prelude,
      name:            "lkn-prelude",
      version:         "0.1.1",
      elixir:          "~> 1.4",
      deps:            deps(),
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps(),
      description:     description(),
      source_url:      "https://nest.pijul.com/lthms/lkn-prelude:lkn-prelude-0.1.1",
      package:         package(),
      test_coverage:   [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        "coveralls":        :test,
        "coveralls.detail": :test,
        "coveralls.post":   :test,
        "coveralls.html":   :test,
      ],
      dialyzer: [
        flags: [
          "-Wunmatched_returns",
          :error_handling,
          :race_conditions,
          :underspecs,
        ],
      ],
    ]
  end

  def application do
    []
  end

  def description do
    """
    An opiniated yet generic prelude for lkn.
    """
  end

  defp deps do
    [
      {:credo,       "~> 0.4",  only: [:dev, :test], runtime: false},
      {:dialyxir,    "~> 0.5",  only: :dev,          runtime: false},
      {:ex_doc,      "~> 0.15", only: :dev,          runtime: false},
      {:excoveralls, "~> 0.6",  only: :test,         runtime: false},
    ]
  end

  defp package do
    [
      name: :lkn_prelude,
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "LICENSE",
      ],
      maintainers: [
        "Thomas Letan"
      ],
      licenses: [
        "GPL 3.0"
      ],
      links: %{
        "Pijul Nest" => "https://nest.pijul.com/lthms/lkn-prelude:lkn-prelude-0.1.1",
      },
    ]
  end
end
