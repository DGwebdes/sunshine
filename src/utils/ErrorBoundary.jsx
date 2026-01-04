import { Component } from "react";

class ErrorBoundary extends Component {
    constructor(props) {
        super(props);
        this.state = { hasError: false };
    }
    static getDerivedStateFromError(error) {
        return { hasError: true };
    }
    componentDidCatch(error, errorInfo) {
        console.log("Error occurred: ", error, errorInfo);
    }

    render() {
        if (this.state.hasError) {
            return (
                <h1 className="text-3xl text-red-500 text-center">
                    Something went wrong. Please try again later.
                </h1>
            );
        }
        return this.props.children;
    }
}

export default ErrorBoundary;
