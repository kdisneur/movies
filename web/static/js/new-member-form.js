class NewMemberForm extends React.Component {
  constructor(props) {
    super(props)
    this.state = { opened: props.opened, username: props.username }
  }

  handleSubmit(event) {
    event.preventDefault()

    if (this.state.opened) {
      event.target.submit();
    }

    this.setState({ opened: true }, () => React.findDOMNode(this.refs.username).focus())
  }

  render() {
    let classes = classNames({
      "form-control": true,
      "hide":         !this.state.opened
    })

    return <form action="/admin/members" method="post" onSubmit={this.handleSubmit.bind(this)}>
      <input type="hidden" name="_csrf_token" value={this.props.csrf_token} />
      <div className="input-group">
        <input ref="username" name="user[username]" type="text" placeholder="Trakt.tv username" className={classes} defaultValue={this.state.username} />
        <div className="input-group-btn">
          <button className="btn btn-success">Allow a new member</button>
        </div>
      </div>
    </form>;
  }
}

if ($('.new-member-form-js').length > 0) {
  let $member = $('.new-member-form-js');
  React.render(<NewMemberForm csrf_token={$("meta[name=csrf-token]").attr("value")} opened={$member.data('opened')} username={$member.data('username')} />, $member[0]);
}
