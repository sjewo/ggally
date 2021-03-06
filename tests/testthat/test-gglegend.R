

context("gglegend")

ex_print <- function(p) {
  expect_silent(print(p))
}

test_that("examples", {
  library(ggplot2)

  histPlot <- qplot(
    x = Sepal.Length,
    data = iris,
    fill = Species,
    geom = "histogram",
    binwidth = 1/4
  )

  (right <- histPlot)
  (bottom <- histPlot + theme(legend.position = "bottom"))
  (top <- histPlot + theme(legend.position = "top"))
  (left <- histPlot + theme(legend.position = "left"))


  expect_legend <- function(p) {
    plotLegend <- grab_legend(p)
    expect_true(inherits(plotLegend, "gtable"))
    expect_true(inherits(plotLegend, "gTree"))
    expect_true(inherits(plotLegend, "grob"))
    ex_print(plotLegend)
  }

  expect_legend(right)
  expect_legend(bottom)
  expect_legend(top)
  expect_legend(left)

})


test_that("legend", {

  # display regular plot
  ex_print(
    ggally_points(iris, ggplot2::aes(Sepal.Length, Sepal.Width, color = Species))
  )

  # Make a function that will only print the legend
  points_legend <- gglegend(ggally_points)
  ex_print(points_legend(
    iris, ggplot2::aes(Sepal.Length, Sepal.Width, color = Species)
  ))

  # produce the sample legend plot, but supply a string that 'wrap' understands
  same_points_legend <- gglegend("points")
  expect_identical(
    attr(attr(points_legend, "fn"), "original_fn"),
    attr(attr(same_points_legend, "fn"), "original_fn")
  )

  # Complicated examples
  custom_legend <- wrap(gglegend("points"), size = 6)
  p <- custom_legend(
    iris, ggplot2::aes(Sepal.Length, Sepal.Width, color = Species)
  )
  ex_print(p)
  expect_true(inherits(p, "gtable"))
  expect_true(inherits(p, "gTree"))
  expect_true(inherits(p, "grob"))

  # Use within ggpairs
  expect_silent({
    pm <- ggpairs(
     iris, 1:2,
     mapping = ggplot2::aes(color = Species),
     upper = list(continuous = gglegend("points"))
    )
    print(pm)
  })

  # Use within ggpairs
  expect_silent({
    pm <- ggpairs(
     iris, 1:2,
     mapping = ggplot2::aes(color = Species)
    )
    pm[1,2] <- points_legend(iris, ggplot2::aes(Sepal.Width, Sepal.Length, color = Species))
    print(pm)
  })

})
