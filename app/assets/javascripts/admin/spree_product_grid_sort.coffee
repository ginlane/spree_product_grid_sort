#= require jquery
#= require admin/spree_backend
#= require admin/jquery.gridster

(exports ? this).ReorderPage = class ReorderPage

  constructor: ->
    $("#taxon_menu").on "change", @navigate
    if !!$(".classification-block").length
      @initializeGrid()

  initializeGrid: =>
    options =
      widget_margins: [10, 10]
      widget_base_dimensions: [140, 260]
      min_cols: 6 # TODO: CONFIGME
      draggable: { stop:  @updateGridOrder }
      serialize_params: @extractGridOrder

    @grid = $(".classification-grid ul").gridster(options).data("gridster")
    $("#admin_save_grid_order").on "click", @saveGridOrder


  navigate: (e) =>
    menu            = $("#taxon_menu")
    window.location = menu.attr("data-url") + "/?taxon_id=" + menu.val()

  extractGridOrder: ($w, wgd) =>
    pos = ((wgd.row-1)*6) + wgd.col
    [ $w.data("id"), pos ]

  updateGridOrder: (e) =>
    @gridOrder = @grid.serialize()

  saveGridOrder: (e) =>
    e.preventDefault()
    return unless @gridOrder
    $.ajax
      type: "PUT"
      url: e.currentTarget.getAttribute("href")
      data: { reorder: JSON.stringify(@gridOrder), taxon_id: $("#taxon_menu").val() }
      success: =>
        # console.log(@gridOrder)


$(document).ready ->
  new ReorderPage()
