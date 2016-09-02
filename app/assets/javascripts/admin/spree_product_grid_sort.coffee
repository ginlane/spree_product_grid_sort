#= require jquery
#= require admin/spree_backend
#= require admin/jquery.gridster

(exports ? this).ReorderPage = class ReorderPage

  constructor: ->
    $("#taxon_menu").on "change", @taxon_navigate
    $('#store_menu').on 'change', @store_navigate if $('#store_menu').length > 0
    if !!$(".classification-block").length
      @initializeGrid()

  initializeGrid: =>
    options =
      stop: @updateGridOrder

    @grid = $(".classification-grid ul").sortable(options)
    $("#admin_save_grid_order").on "click", @saveGridOrder

  # Returns all but the url property of a data object returned by jQuery's data() function.
  filterData = (data) ->
    filtered = new Object()
    for own key, value of data
      filtered[key] = data[key] unless key == "url"
    filtered

  # All HTML5 data attributes except url will be turned into query params
  # on the window.location URL.
  taxon_navigate: (e) ->
    menu            = $("#taxon_menu")
    data            = menu.data()
    filtered_data   = filterData(data)
    filtered_data['taxon_id'] = menu.val()
    window.location = data.url + "?" + $.param(filtered_data)

  # All HTML5 data attributes except url will be turned into query params
  # on the window.location URL.
  store_navigate: (e) ->
    menu            = $("#store_menu")
    data            = menu.data()
    filtered_data   = filterData(data)
    filtered_data['store_id'] = menu.val()
    window.location = data.url + "?" + $.param(filtered_data)

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
