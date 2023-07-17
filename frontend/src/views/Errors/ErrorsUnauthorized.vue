<template>
  <v-container>
    <v-row>
      <v-col md="8" offset-md="2">
        <v-card flat color="#121212" class="text-center">
          <v-card-subtitle>
            このサービスを利用するには Sign Up または、Log In してください。
          </v-card-subtitle>
          <v-card-actions>
            <v-spacer />
            <v-btn to="/signup" color="grey lighten-2" text class="text-h6">
              Sign Up
            </v-btn>
            <v-spacer />
          </v-card-actions>
          <v-card-actions>
            <v-spacer />
            <v-btn to="/login" color="grey lighten-2" text class="text-h6">
              Log In
            </v-btn>
            <v-spacer />
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>
