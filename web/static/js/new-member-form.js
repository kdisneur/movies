let NewOneValueForm = require("/web/static/js/components/new-one-value-form")

class NewMemberForm extends React.Component {
  render() {
    return <NewOneValueForm opened={this.props.opened}
                            action="/admin/members"
                            csrf_token={this.props.csrf_token}
                            elementName="user[username]"
                            elementPlaceholder="Trakt.tv username"
                            elementValue={this.props.username}
                            actionButtonValue="Allow a new member" />
  }
}

export default NewMemberForm
