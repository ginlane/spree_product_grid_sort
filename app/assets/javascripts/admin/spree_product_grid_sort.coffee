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
      stop: @updateGridOrder

    @grid = $(".classification-grid ul").sortable(options)
    $("#admin_save_grid_order").on "click", @saveGridOrder

  navigate: (e) =>
    menu            = $("#taxon_menu")
    window.location = menu.attr("data-url") + "/?taxon_id=" + menu.val()

  extractGridOrder: ($w, wgd) =>
    pos = ((wgd.row-1)*6) + wgd.col
    [ $w.data("id"), pos ]

  updateGridOrder: (e) =>
    positionArray = @grid.sortable("toArray")
    gridOrder = []
    positionArray.forEach (item, i)->
      gridOrder.push([parseInt(item.split('_')[1]), i+1])
    @gridOrder = gridOrder

  saveGridOrder: (e) =>
    e.preventDefault()
    return unless @gridOrder
    $.ajax
      type: "PUT"
      url: e.currentTarget.getAttribute("href")
      data: { reorder: JSON.stringify(@gridOrder), taxon_id: $("#taxon_menu").val(), grid_id: $("#grid_id").val() }
      success: =>
        show_flash 'success', 'Grid saved successfully.'
        location.reload()
      error: (response) =>
        show_flash 'error', response.responseJSON?.error || 'Grid saving failed!'


$(document).ready ->
  new ReorderPage()
