import React, { Component }from 'react';
import 'semantic-ui-css/semantic.min.css';

import {
  Header,
  Message,
  Button,
  Container,
  Form,
  Segment,
  Step,
  Icon,
  Dropdown
} from 'semantic-ui-react';

import axios from 'axios';

const API = 'http://track-api.ctomate.com';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      trackingId: '',
      courier: '',
      checkpoints: [],
      isLoading: false,
      message_hidden: true
    };
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  placeTracking = e => this.setState({ trackingId: e.target.value })
  selectCourier = (e, { value }) => this.setState({ courier: value })
  handleDismiss = () => {
    this.setState({ message: false })
  }

  async handleSubmit(e) {
    this.setState({isLoading: true});
    e.preventDefault()
    const { courier, trackingId } = this.state;
    const query = `/trackings/${courier}/${trackingId}`
    const req = axios.create({
      baseURL: API,
      headers: {
        'Content-Type': 'application/json',
      },
    });
    try {
      const result = await req.get(query);
      console.log(result.data.checkpoints);
      this.setState({
        checkpoints: result.data.checkpoints,
        message_hidden: true
      });
    } catch (error) {
      this.setState({
        message_hidden: false
      });
    }
    this.setState({isLoading: false});
  }

  render() {
   let steps = []
   this.state.checkpoints.map(checkpoint =>
          steps.push(
          {
            'key': checkpoint.message,
            'title': checkpoint.location,
            'description': checkpoint.message,
            'date': checkpoint.checkpoint_time
          }
          )
    )
    const couriers = [
      {"key": "kerry-logistics", "value": "kerry-logistics", "text": "kerry-logistics"},
      {"key": "thailand-post", "value": "thailand-post", "text": "thailand-post"},
      {"key": "cj-korea-thai", "value": "cj-korea-thai", "text": "cj-korea-thai"},
      {"key": "ninjavan-thai", "value": "ninjavan-thai", "text": "ninjavan-thai"}
    ];

    return (
      <div className="App">
      <Container textAlign='center' style={{marginTop: '50px'}}>
        <Header as='h1'>ตรวจสอบเลข Tracking</Header>
        <Segment>
          <Form onSubmit={this.handleSubmit}>
            <Form.Group grouped>
              <Dropdown placeholder='เลือกขนส่ง'
                  onChange={this.selectCourier}
                  fluid selection options={couriers} />
              <Form.Input name='trackingid' onChange={this.placeTracking} placeholder='Tracking Number' />
              <Button type='submit' content='Submit' color="orange" loading={this.state.isLoading} />
            </Form.Group>
          </Form>
        </Segment>
        <Message
          content='ไม่พบ Tracking ID นี้'
          hidden={this.state.message_hidden}
        />
       <Step.Group vertical>
        {steps.reverse().map( (st) => {
                return (
                 <Step completed={st.description === 'Delivered Successful'}>
                    <Icon name='truck' />
                    <Step.Content>
                      <Step.Title>{st.date} - {st.title}</Step.Title>
                      <Step.Description>{st.description}</Step.Description>
                    </Step.Content>
                  </Step>
            );
          }
         )
        }
      </Step.Group>
      </Container>
      </div>
    )
  }
}

export default App;
