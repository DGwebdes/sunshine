import { useForm, ValidationError } from "@formspree/react";

function ContactForm() {
    const [state, handleSubmit] = useForm("xanejvev");
    if (state.succeeded) {
        return <p>We will get in touch soon! 🎨</p>;
    }
    return (
        <form
            onSubmit={handleSubmit}
            className="flex flex-col gap-2"
        >
            <label htmlFor="name">Name</label>
            <input
                className="border-r-12 border-b-2 bg-[#F0EFF4] rounded-lg p-1"
                id="name"
                type="text"
                name="name"
            />
            <ValidationError
                prefix="Name"
                field="name"
                errors={state.errors}
            />
            <label htmlFor="email">Email Address</label>
            <input
                className="border-r-12 border-b-2 bg-[#F0EFF4] rounded-lg p-1"
                id="email"
                type="email"
                name="email"
            />
            <ValidationError
                prefix="Email"
                field="email"
                errors={state.errors}
            />
            <label htmlFor="message">Message</label>
            <textarea
                className="resize-none bg-[#F0EFF4] rounded-lg border-b-2 p-1"
                id="message"
                name="message"
                rows={10}
            />
            <ValidationError
                prefix="Message"
                field="message"
                errors={state.errors}
            />
            <button
                className="border-2 rounded-xl bg-violet-400 hover:bg-blue-50 transition duration-500 hover:cursor-pointer p-2"
                type="submit"
                disabled={state.submitting}
            >
                Submit
            </button>
        </form>
    );
}

const Contact = () => {
    return (
        <section
            id="contact"
            className="border-t min-h-screen md:h-screen flex flex-col justify-center items-center gap-1"
        >
            <div className="p-2 w-full h-[80%] md:h-[90%] flex flex-col gap-10">
                <div className="place-self-start place-content-start mt-5">
                    <h2 className="font-[Boldonse] text-5xl md:text-7xl">
                        Hello
                    </h2>
                    <h3 className="text-3xl md:text-5xl text-amber-500">
                        Let's Talk
                    </h3>
                </div>
                <div className="md:flex justify-around gap-5">
                    <div className="flex-1 mb-10">
                        <h2 className="text-xl md:text-2xl">
                            Have any questions? Please feel free to ask
                        </h2>
                        <p className="mt-2 md:text-lg">
                            Location: <span className="italic">Albufeira</span>{" "}
                        </p>
                    </div>
                    <div className="flex-2">
                        <ContactForm />
                    </div>
                </div>
            </div>
        </section>
    );
};

export default Contact;
