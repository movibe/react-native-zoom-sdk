/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react'
import { StyleSheet, NativeModules } from 'react-native'
import { Button, Text, Container, Header, Content, Body } from 'native-base'
import ZoomAuth from  'react-native-zoom-sdk'

const appToken = 'your token'
const userId = 'user'
const encrypt = 'encrypt'
const secret = 'secr3t'

console.log({ZoomAuth})

export default class App extends Component<{}> {
    constructor(props) {
        super(props)
        this.state = {
            version: null,
            auth: true,
        }
    }

    componentWillMount() {
        this.onVersion()
    }

    onVersion = async () => {
        try {
            const version = await ZoomAuth.getVersion()
            this.setState({ version })
        } catch (err) {
            console.log({ err })
        }
    }

    startSdk = async () => {
      try {
          const auth = await ZoomAuth.initialize(appToken, secret, userId, encrypt)
          console.log({ auth })
          this.setState({auth: false})
      } catch (err) {
          console.log({ err })
      }
  }

    onEroll = async () => {
        try {
            const enroll = await ZoomAuth.onEnrollPressed()
            console.log({ enroll })
        } catch (err) {
            console.log({ err })
        }
    }

    onAuth = async () => {
      try {
          const enroll = await ZoomAuth.onAuth()
          console.log({ enroll })
      } catch (err) {
          console.log({ err })
      }
  }

    render() {
        return (
            <Container>
                <Header>
                    <Body><Text>ZoomAuth</Text></Body>
                </Header>
                <Content padder>
                    <Button 
                      block 
                      info 
                      onPress={ this.startSdk } 
                      style={styles.button}>
                        <Text>INIT</Text>
                    </Button>
                    <Button 
                      block 
                      info 
                      disabled={this.state.auth} 
                      onPress={ this.onEroll } 
                      style={styles.button}>
                        <Text>ENROLL</Text>
                    </Button>
                    <Button 
                      block 
                      info 
                      disabled={this.state.auth} 
                      onPress={ this.onAuth } 
                      style={styles.button}>
                        <Text>AUTHENTICATE</Text>
                    </Button>

                    <Text style={ styles.welcome }>
                        SDK Version { this.state.version }
                    </Text>
                </Content>
            </Container>
        )
    }
}

const styles = StyleSheet.create({
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    button: {
        marginBottom: 5,
    },
})
