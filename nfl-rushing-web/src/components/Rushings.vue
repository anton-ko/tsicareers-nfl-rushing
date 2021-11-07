<template>
  <div class="rushings">
    <div class="justify-center flex bg-blue-100 items-center p-1">
      <div class="text-4xl">
        Rushings 🏈
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Rushings',
  props: {
    msg: String
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
