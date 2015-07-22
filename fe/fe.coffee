$ = require 'jquery'
_ = require 'lodash'

$ ->
  $filter       = $ '.tag-filter'
  $tag          = $filter.find '.tag'
  $links        = $ '.page-link'
  $articleLinks = $ 'article a'

  showFilter = (tag) ->
    $tag.html tag
    if tag then $filter.removeClass 'hide' else $filter.addClass 'hide'

  showTag = (tag) ->
    $links.removeClass 'hide'

    if tag
      _.each ($ '.page-link'), (el) ->
        $el = $ el
        $el.addClass 'hide' unless $el.find(".tag[data-tag=#{tag}]").length > 0

  filter = (tag) ->
    showTag tag
    showFilter tag

  ($ 'a.tag').click (event) ->
    tag = ($ event.currentTarget).data 'tag'
    filter tag

  ($filter.find '.unfilter').click ->
    filter()

  $articleLinks.attr 'target', '_blank' unless location.pathname == '/'
