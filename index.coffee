
getNodeType = (node)->
  return node.constructor.name

isErrorVariable = (var_name)->
  regex = ///
    (^err(or)?$)
    | (_err(or)?$)
    | (^err(or)?_)
  ///i
  return regex.test var_name

module.exports = class CallbackHandleError
  rule:
    name: 'callback_handle_error'
    level: 'error'
    message: 'Error in callback not handled'
    description: '''
      Finds instances of error objects passed through a callback not being handled
    '''

  lintAST: (node, astApi) ->
    @astApi = astApi
    @lintNode node
    return

  lintNode: (node)->
    node_type = getNodeType(node)

    switch node_type
      when 'Code'
        for param in node.params
          var_name = param.name?.value
          if isErrorVariable var_name
            if not @handlesError node, var_name
              @throwError node, "Error object '#{var_name}' in callback not handled"

    node.eachChild (child)=>
      @lintNode child
      return
    return

  handlesError: (code_node, var_name)->
    found_usage = false

    code_node.traverseChildren true, (child)->

      node_type = getNodeType child

      switch node_type
        when 'If'
          # check for if they use the error in an if
          child.condition.traverseChildren false, (inner_child)->
            inner_type = getNodeType inner_child
            switch inner_type
              # HACK: Handles change of token naming in CoffeeScript 1.11.0
              when 'Literal', 'IdentifierLiteral'
                if inner_child.value is var_name
                  found_usage = true
                  return false
            return

        when 'Call'
          # passing the error to another call is considered using it
          for arg in child.args
            arg.traverseChildren false, (inner_child)->
              inner_type = getNodeType inner_child
              switch inner_type
                # HACK: Handles change of token naming in CoffeeScript 1.11.0
                when 'Literal', 'IdentifierLiteral'
                  if inner_child.value is var_name
                    found_usage = true
                    return false
              return
          return

        when 'Code'
          # stop going down the chain when the var gets overwritten with another param
          for param in child.params
            inner_child_type = getNodeType param
            if inner_child_type is 'Param'
              if param.name.value is var_name
                return false

      # if we already found a usage, break out of the traverse
      if found_usage
        return false
      return

    return found_usage

  throwError: (node, message)->
    err = @astApi.createError
      lineNumber: node.locationData.first_line + 1
      message: message
    @errors.push err
    return
