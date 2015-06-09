let NewOneValueForm = require("/web/static/js/components/new-one-value-form")

class NewLanguageForm extends React.Component {
  render() {
    return <NewOneValueForm opened={this.props.opened}
                            action="/admin/languages"
                            csrf_token={this.props.csrf_token}
                            elementName="language[name]"
                            elementPlaceholder="english, french, ..."
                            elementValue={this.props.language}
                            actionButtonValue="Allow a new language" />
  }
}

export default NewLanguageForm
