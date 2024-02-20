/**
 * This function handles the event request and modifies the headers.
 * It sets the 'x-forwarded-host' header to the value of the 'host' header.
 *
 * @param {Object} event - The event object containing the request.
 * @returns {Object} The modified request object.
 */

function handler(event) {
  var request = event.request;
  request.headers["x-forwarded-host"] = request.headers.host;
  return request;
}
